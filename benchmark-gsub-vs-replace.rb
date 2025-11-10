require "benchmark"
require "cgi"

n = 5000000
log_line = '2025-10-12	09:52:59	MRS53-P3	1400	150.107.232.112	POST	d2p1j3y3mcauy0.cloudfront.net	/plugin/add	403	-	Mozilla/5.0%20(Macintosh;%20Intel%20Mac%20OS%20X%2010_15_7)%20AppleWebKit/605.1.15%20(KHTML,%20like%20Gecko)%20Version/17.3.1%20Safari/605.1.1%0920.51	-	-	Error	WcPCNG0WyL4BbXhEXq4AQulhrqte2TPUHt1Uz-iqcSwtx1L6ORdTOA==	livecdn.kerkdienstgemist.nl	https	9760	0.124	-	TLSv1.3	TLS_AES_128_GCM_SHA256	Error	HTTP/1.1	-	-	50294	0.000	InvalidRequestMethod	text/html	1053	-	-'
Benchmark.bm do |x|
  x.report do
    n.times do
      log_line = '2025-10-12	09:52:59	MRS53-P3	1400	150.107.232.112	POST	d2p1j3y3mcauy0.cloudfront.net	/plugin/add	403	-	Mozilla/5.0%20(Macintosh;%20Intel%20Mac%20OS%20X%2010_15_7)%20AppleWebKit/605.1.15%20(KHTML,%20like%20Gecko)%20Version/17.3.1%20Safari/605.1.1%0920.51	-	-	Error	WcPCNG0WyL4BbXhEXq4AQulhrqte2TPUHt1Uz-iqcSwtx1L6ORdTOA==	livecdn.kerkdienstgemist.nl	https	9760	0.124	-	TLSv1.3	TLS_AES_128_GCM_SHA256	Error	HTTP/1.1	-	-	50294	0.000	InvalidRequestMethod	text/html	1053	-	-'
      CGI.unescape(log_line.gsub('%09', " "))
      log_line
    end
  end

  x.report do
    n.times do
      log_line = '2025-10-12	09:52:59	MRS53-P3	1400	150.107.232.112	POST	d2p1j3y3mcauy0.cloudfront.net	/plugin/add	403	-	Mozilla/5.0%20(Macintosh;%20Intel%20Mac%20OS%20X%2010_15_7)%20AppleWebKit/605.1.15%20(KHTML,%20like%20Gecko)%20Version/17.3.1%20Safari/605.1.1%0920.51	-	-	Error	WcPCNG0WyL4BbXhEXq4AQulhrqte2TPUHt1Uz-iqcSwtx1L6ORdTOA==	livecdn.kerkdienstgemist.nl	https	9760	0.124	-	TLSv1.3	TLS_AES_128_GCM_SHA256	Error	HTTP/1.1	-	-	50294	0.000	InvalidRequestMethod	text/html	1053	-	-'
      log_line["%09"] = " " if log_line.include?("%09")
      CGI.unescape(log_line)
      log_line
    end
  end
end
