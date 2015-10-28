all:  build


build: 
	GOPATH=`pwd`:`pwd`/vendor go build -o bin/lastore-daemon lastore-daemon

install: 
	mkdir -p ${DESTDIR}${PREFIX}/usr/bin && cp bin/lastore-daemon ${DESTDIR}${PREFIX}/usr/bin/
	mkdir -p ${DESTDIR}${PREFIX}/usr && cp -rf usr ${DESTDIR}${PREFIX}/
	cp -rf etc ${DESTDIR}${PREFIX}/etc
	mkdir -p ${DESTDIR}${PREFIX}/var/lib/lastore/
	cp -rf var/lib/lastore/* ${DESTDIR}${PREFIX}/var/lib/lastore/



gen-xml:
	qdbus --system org.deepin.lastore /org/deepin/lastore org.freedesktop.DBus.Introspectable.Introspect > usr/share/dbus-1/interfaces/org.deepin.lastore.xml
	qdbus --system org.deepin.lastore /org/deepin/lastore/Job1 org.freedesktop.DBus.Introspectable.Introspect > usr/share/dbus-1/interfaces/org.deepin.lastore.Job.xml

gen-dbus-codes:
	~/prj/dbus-generator/dbus-generator -o usr/include/lastore-daemon.h usr/share/dbus-1/interfaces/*.xml


build-deb:
	yes | debuild -us -uc

clean:
	rm -rf bin
	rm ../lastore-daemon_* -rf

bin/tools:
	gb build tools

var/lib/lastore: var/lib/lastore/application.json var/lib/lastore/categories.json var/lib/lastore/xcategories.json

var/lib/lastore/application.json: bin/tools
	mkdir -p var/lib/lastore
	./bin/tools -item applications -output $@

var/lib/lastore/categories.json: bin/tools
	mkdir -p var/lib/lastore
	./bin/tools -item categories -output  $@

var/lib/lastore/xcategories.json: bin/tools
	mkdir -p var/lib/lastore
	./bin/tools -item xcategories -output  $@
