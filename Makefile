all: build

clean:
	rm -f *.log *.box site.retry

destroy: clean
	vagrant destroy -f
	rm -rf .vagrant

.vagrant:
	vagrant up --provision

build: .vagrant

package.box: .vagrant
	vagrant halt
	vagrant package default --output package.box

rebuild: destroy build

import: package.box
	vagrant box add --force seravo/wordpress-beta package.box

rimport: rebuild import