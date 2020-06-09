default: init test

test:
	ansible-playbook -u root site.yml -C

deploy:
	ansible-playbook -u root site.yml
