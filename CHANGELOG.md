## Release 0.2.2
- [end] replace slow gsub with more efficient string replace

## Release 0.2.1
Merge pull request #1 from kdgm/feature/fix/escaped-tab-handling

## Release 0.2.0 (kjwierenga)
Merge branch 'feature/enh/rename-to-optimized' into develop
Merge branch 'feature/fix/process-log-files-in-last-modified-order' into develop
- [fix] process log files in order of ascending last_modified time
Merge branch 'feature/enh/reduce-memory-usage' into develop
- [enh] process log files with (small) constant memory usage even for very large log files
- [add] EnumerableInflater so we can inflate the .gz file in a streaming fashion (greatly reducing memory usage)
- [enh] transpose.to_h is faster than Hash[....zip(line)]
Merge branch 'feature/fix/unescape-once' into develop
- [enh] URI.unescape is deprecated and CGI.unescape is faster
- [fix] unescape once; CloudFront encodes once so we should unescape once
Merge branch 'feature/enh/optional-parse-date-time' into develop
- [enh] use Time.iso8601 which is much faster than the Time.parse
- [add] option to make parsing of date time optional
Merge branch 'feature/enh/modernize-tests' into develop
Merge branch 'feature/fix/verbose-param' into develop
- [fix] verbose flag; it was set to string causing it to be always enabled

## Release 0.1.1 (packetloop)
- Packetloop 2019 version

## Release 0.0.5 (kubihie)
- Original 2016 version
