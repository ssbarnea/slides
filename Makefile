all: build

prepare:
	echo

build:
	hugo --cleanDestinationDir --i18n-warnings --ignoreCache

clean:
	rm -rf public/

deploy: build
	hugo deploy -v --maxDeletes 0
	# --dryRun

serve:
	bash -c "killall hugo; hugo server -p 1313 -D --noHTTPCache"

stop:
	killall hugo
