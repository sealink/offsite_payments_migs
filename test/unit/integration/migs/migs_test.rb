require 'test_helper'

class MigsTest < Test::Unit::TestCase
  DIGEST = OpenSSL::Digest.new('sha256')
  def setup
    @cents       = 2995
    @merchant_id = 'MER123'
    @order_info  = '22TEST'
    @secure_hash = '76AF3392002D202A60D0AB5F9D81653C'
    @helper = OffsitePayments::Integrations::Migs::Helper.new(
                @order_info,
                @merchant_id,
                password: 'password',
                secure_hash: @secure_hash,
                unique_id: 'uniq',
                cents: @cents,
                return_url: 'http://example.org/return'
              )
  end

  def test_credential_based_url
    assert_equal @helper.credential_based_url,
                 'https://migs.mastercard.com.au/vpcpay'+
                 '?vpc_OrderInfo=22TEST'+
                 '&vpc_Amount=2995'+
                 '&vpc_Version=1'+
                 '&vpc_Merchant=MER123'+
                 '&vpc_AccessCode=password'+
                 '&vpc_Command=pay'+
                 '&vpc_MerchTxnRef=uniq'+
                 '&vpc_Locale=en'+
                 '&vpc_ReturnURL=http%3A%2F%2Fexample.org%2Freturn'+
                 '&vpc_SecureHash=2E400878DF5A4C1DD700A56F5F9B85DF4B6F158D078AFEF9A955DA2A75FD9F61'+
                 '&vpc_SecureHashType=SHA256'
  end

  def test_secure_hash
    ordered_values = "vpc_Amount=#{@cents}&vpc_MerchantId=#{@merchant_id}&vpc_OrderInfo=#{@order_info}"
    calculated = OffsitePayments::Integrations::Migs::SecureHash.calculate(
                   @secure_hash,
                   Amount: @cents,
                   MerchantId: @merchant_id,
                   OrderInfo: @order_info
                 )
    assert_equal OpenSSL::HMAC.hexdigest(DIGEST, [@secure_hash].pack('H*'), ordered_values).upcase, calculated
  end

  def test_purchase_offsite_response
    # Below response from instance running remote test
    response_string =
      "vpc_3DSXID=a1B8UcW%2BKYqkSinLQohGmqQd9uY%3D"\
      "&vpc_3DSenrolled=U"\
      "&vpc_AVSResultCode=Unsupported"\
      "&vpc_AcqAVSRespCode=Unsupported"\
      "&vpc_AcqCSCRespCode=Unsupported"\
      "&vpc_AcqResponseCode=00"\
      "&vpc_Amount=100"\
      "&vpc_AuthorizeId=367739"\
      "&vpc_BatchNo=20120421"\
      "&vpc_CSCResultCode=Unsupported"\
      "&vpc_Card=MC"\
      "&vpc_Command=pay"\
      "&vpc_Locale=en"\
      "&vpc_MerchTxnRef=9"\
      "&vpc_Merchant=TESTANZTEST3"\
      "&vpc_Message=Approved"\
      "&vpc_OrderInfo=1"\
      "&vpc_ReceiptNo=120421367739"\
      "&vpc_SecureHash=20DE2CDEBE40D6F24E3ABC5D74081CB5B341CD447530121AD51A9504A923BBD0"\
      "&vpc_TransactionNo=2000025183"\
      "&vpc_TxnResponseCode=0"\
      "&vpc_VerSecurityLevel=06"\
      "&vpc_VerStatus=U"\
      "&vpc_VerType=3DS"\
      "&vpc_Version=1"

    response_params = response_string_to_params(response_string)
    notification_class = OffsitePayments::Integrations::Migs::Notification
    opts = { secure_hash: @secure_hash }
    notification = notification_class.new(response_params, opts)
    assert_equal '20DE2CDEBE40D6F24E3ABC5D74081CB5B341CD447530121AD51A9504A923BBD0',
                 notification.expected_secure_hash

    assert notification.success?

    tampered_params1 = response_params.merge(
      'vpc_SecureHash' =>
      response_params['vpc_SecureHash'].gsub('24E3', '93F8')
    )
    tampered_notification1 = notification_class.new(tampered_params1, opts)
    assert_raise(SecurityError) { tampered_notification1.acknowledge }

    tampered_params2 = response_params.merge(
      'vpc_Locale' =>
      response_params['vpc_Locale'].gsub('en', 'es')
    )
    tampered_notification2 = notification_class.new(tampered_params2, opts)
    assert_raise(SecurityError) { tampered_notification2.acknowledge }
  end

  private

  def response_string_to_params(string)
    string.split('&').map.with_object({}) { |obj, hash|
      key, value = obj.split('=')
      hash[key] = URI.unescape(value)
    }
  end
end
