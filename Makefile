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
	vagrant up
	vagrant ssh -c "rm /home/vagrant/.nodocker"
	vagrant halt
	vagrant package default

rebuild: destroy build

import: package.box
	vagrant box add --force seravo/wordpress-beta package.box
