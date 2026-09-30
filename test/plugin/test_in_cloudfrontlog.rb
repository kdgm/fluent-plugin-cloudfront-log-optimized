require_relative '../helper'
require 'fluent/test'
require 'fluent/test/driver/input'

class Cloudfront_LogInputTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  MINIMAL_CONFIG = %[
    region     ap-northeast-1
    log_bucket bucket-name
    log_prefix a/b/c

    # aws_key_id       AKIAZZZZZZZZZZZZZZZZ
    # aws_sec_key      1234567890qwertyuiopasdfghjklzxcvbnm
    # moved_log_bucket bucket-name-moved
    # moved_log_prefix a/b/c_moved
    # tag              cloudfront
    # interval         500
    # verbose          true
    # thread_num 8
    # parse_date_time false
  ]

  def create_driver(conf = MINIMAL_CONFIG)
    Fluent::Test::Driver::Input.new(Fluent::Cloudfront_LogInput).configure(conf)
  end

  test "create_driver doesn't raise error" do
    assert_nothing_raised { create_driver }
  end

  sub_test_case "required parameters" do
    test "region is required" do
      exception = assert_raise(Fluent::ConfigError) {
        create_driver(MINIMAL_CONFIG.gsub(/region.*$/, ''))
      }
      assert_equal("'region' parameter is required", exception.message)
    end

    test "log_bucket is required" do
      exception = assert_raise(Fluent::ConfigError) {
        create_driver(MINIMAL_CONFIG.gsub(/log_bucket.*$/, ''))
      }
      assert_equal("'log_bucket' parameter is required", exception.message)
    end

    test "log_prefix is required" do
      exception = assert_raise(Fluent::ConfigError) {
        create_driver(MINIMAL_CONFIG.gsub(/log_prefix.*$/, ''))
      }
      assert_equal("'log_prefix' parameter is required", exception.message)
    end
  end

  sub_test_case "default values" do
    test "moved_log_bucket is set to log_bucket" do
      driver = create_driver(MINIMAL_CONFIG)
      assert_equal(driver.instance.log_bucket, driver.instance.moved_log_bucket)
    end

    test "moved_log_prefix is set to '_moved'" do
      driver = create_driver(MINIMAL_CONFIG)
      assert_equal('_moved', driver.instance.moved_log_prefix)
    end

    test "tag is set to 'cloudfront.access'" do
      driver = create_driver(MINIMAL_CONFIG)
      assert_equal('cloudfront.access', driver.instance.tag)
    end

    test "verbose is set to false" do
      driver = create_driver(MINIMAL_CONFIG)
      assert_equal(false, driver.instance.verbose)
    end

    test "interval is set to 300" do
      driver = create_driver(MINIMAL_CONFIG)
      assert_equal(300, driver.instance.interval)
    end

    test "thread_num is set to 4" do
      driver = create_driver(MINIMAL_CONFIG)
      assert_equal(4, driver.instance.thread_num)
    end

    test "s3_get_max is set to 200" do
      driver = create_driver(MINIMAL_CONFIG)
      assert_equal(200, driver.instance.s3_get_max)
    end

    test "parse_date_time true" do
      driver = create_driver(MINIMAL_CONFIG)
      assert_equal(true, driver.instance.parse_date_time)
    end
  end

  sub_test_case "set specific values" do
    test "moved_log_prefix is set to 'my-prefix'" do
      driver = create_driver(MINIMAL_CONFIG + %[
        moved_log_prefix 'my-prefix'
      ])
      assert_equal('my-prefix', driver.instance.moved_log_prefix)
    end
  end

  sub_test_case "regression test for %09 (tab) in log lines" do
    test "log line with %09 in user-agent is parsed correctly" do
      driver = create_driver(MINIMAL_CONFIG)
      instance = driver.instance

      version_line = "#Version: 1.0"
      fields_line = "#Fields: date time x-edge-location sc-bytes c-ip cs-method cs(Host) cs-uri-stem sc-status cs(Referer) cs(User-Agent) cs-uri-query cs(Cookie) x-edge-result-type x-edge-request-id x-host-header cs-protocol cs-bytes time-taken x-forwarded-for ssl-protocol ssl-cipher x-edge-response-result-type cs-protocol-version fle-status fle-encrypted-fields c-port time-to-first-byte x-edge-detailed-result-type sc-content-type sc-content-len sc-range-start sc-range-end"
      regression_line_with_excaped_tab = "2025-10-12	09:52:59	MRS53-P3	1400	150.107.232.112	POST	d2p1j3y3mcauy0.cloudfront.net	/plugin/add	403	-	Mozilla/5.0%20(Macintosh;%20Intel%20Mac%20OS%20X%2010_15_7)%20AppleWebKit/605.1.15%20(KHTML,%20like%20Gecko)%20Version/17.3.1%20Safari/605.1.1%0920.51	-	-	Error	WcPCNG0WyL4BbXhEXq4AQulhrqte2TPUHt1Uz-iqcSwtx1L6ORdTOA==	livecdn.kerkdienstgemist.nl	https	9760	0.124	-	TLSv1.3	TLS_AES_128_GCM_SHA256	Error	HTTP/1.1	-	-	50294	0.000	InvalidRequestMethod	text/html	1053	-	-"

      # Prime the processor with version and fields lines
      instance.process_line(version_line)
      instance.process_line(fields_line)
      emitted_event = instance.process_line(regression_line_with_excaped_tab)

      assert_equal(emitted_event['cs(User-Agent)'], "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Safari/605.1.1 20.51")
    end

    test "log line without %09 in user-agent is parsed correctly" do
      driver = create_driver(MINIMAL_CONFIG)
      instance = driver.instance

      version_line = "#Version: 1.0"
      fields_line = "#Fields: date time x-edge-location sc-bytes c-ip cs-method cs(Host) cs-uri-stem sc-status cs(Referer) cs(User-Agent) cs-uri-query cs(Cookie) x-edge-result-type x-edge-request-id x-host-header cs-protocol cs-bytes time-taken x-forwarded-for ssl-protocol ssl-cipher x-edge-response-result-type cs-protocol-version fle-status fle-encrypted-fields c-port time-to-first-byte x-edge-detailed-result-type sc-content-type sc-content-len sc-range-start sc-range-end"
      regression_line_with_excaped_tab = "2025-10-12	09:52:59	MRS53-P3	1400	150.107.232.112	POST	d2p1j3y3mcauy0.cloudfront.net	/plugin/add	403	-	Mozilla/5.0%20(Macintosh;%20Intel%20Mac%20OS%20X%2010_15_7)%20AppleWebKit/605.1.15%20(KHTML,%20like%20Gecko)%20Version/17.3.1%20Safari/605.1.1-20.51	-	-	Error	WcPCNG0WyL4BbXhEXq4AQulhrqte2TPUHt1Uz-iqcSwtx1L6ORdTOA==	livecdn.kerkdienstgemist.nl	https	9760	0.124	-	TLSv1.3	TLS_AES_128_GCM_SHA256	Error	HTTP/1.1	-	-	50294	0.000	InvalidRequestMethod	text/html	1053	-	-"

      # Prime the processor with version and fields lines
      instance.process_line(version_line)
      instance.process_line(fields_line)
      emitted_event = instance.process_line(regression_line_with_excaped_tab)

      assert_equal(emitted_event['cs(User-Agent)'], "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Safari/605.1.1-20.51")
    end
  end

  sub_test_case "invalid UTF-8 in log lines" do
    FIELDS_LINE = "#Fields: date time x-edge-location sc-bytes c-ip cs-method cs(Host) cs-uri-stem sc-status cs(Referer) cs(User-Agent) cs-uri-query cs(Cookie) x-edge-result-type x-edge-request-id x-host-header cs-protocol cs-bytes time-taken x-forwarded-for ssl-protocol ssl-cipher x-edge-response-result-type cs-protocol-version fle-status fle-encrypted-fields c-port time-to-first-byte x-edge-detailed-result-type sc-content-type sc-content-len sc-range-start sc-range-end"

    def build_line(uri_query:, user_agent: 'Mozilla/5.0')
      [
        '2026-08-07', '19:49:19', 'IAD55-C1', '1234', '1.2.3.4', 'GET', 'd111.cloudfront.net',
        '/path', '200', 'https://example.com/', user_agent, uri_query, '-', 'Hit', 'AbCdEf',
        'www.example.com', 'https', '200', '0.050', '-', 'TLSv1.2', 'ECDHE-RSA-AES128-GCM-SHA256',
        'Hit', 'HTTP/2.0', '-', '-', '54321', '0.010', 'Hit', 'text/html', '1234', '-', '-'
      ].join("\t")
    end

    def prime_and_process(instance, line)
      instance.process_line("#Version: 1.0")
      instance.process_line(FIELDS_LINE)
      instance.process_line(line)
    end

    test "scrubs invalid UTF-8 bytes without raising" do
      driver = create_driver(MINIMAL_CONFIG)
      line = build_line(uri_query: "q=bad\xFFbyte&x=1", user_agent: "Mozilla/\x80Bot")

      emitted_event = nil
      assert_nothing_raised {
        emitted_event = prime_and_process(driver.instance, line)
      }

      assert_equal(true, emitted_event['cs-uri-query'].encoding == Encoding::UTF_8)
      assert_equal(true, emitted_event['cs-uri-query'].valid_encoding?)
      assert_equal(true, emitted_event['cs(User-Agent)'].valid_encoding?)
      assert_equal(true, emitted_event['cs-uri-query'].include?('q=bad'))
      assert_equal(true, emitted_event['cs(User-Agent)'].include?('Mozilla/'))
    end

    test "preserves valid Unicode percent-encoding" do
      driver = create_driver(MINIMAL_CONFIG)
      line = build_line(uri_query: 'q=%C3%A7af%C3%A9&name=Jo%C3%A3o')

      emitted_event = prime_and_process(driver.instance, line)

      assert_equal(true, emitted_event['cs-uri-query'].include?('çafé'))
      assert_equal(true, emitted_event['cs-uri-query'].include?('João'))
    end

    test "decodes Latin-1 percent-encoding without raising" do
      driver = create_driver(MINIMAL_CONFIG)
      # Real CloudFront case: "métricas" encoded as Latin-1 %E9 instead of UTF-8 %C3%A9
      line = build_line(uri_query: 'q=5%20m%E9tricas%20que%20te%20pueden%20servir')

      emitted_event = nil
      assert_nothing_raised {
        emitted_event = prime_and_process(driver.instance, line)
      }

      assert_equal(true, emitted_event['cs-uri-query'].valid_encoding?)
      assert_equal(true, emitted_event['cs-uri-query'].include?('métricas'))
    end
  end

end
