default: init test
	
init:
	ansible-galaxy install --force -r remote_roles.yml

test:
	ansible-playbook -u root site.yml -C

deploy:
	ansible-playbook -u root site.yml
