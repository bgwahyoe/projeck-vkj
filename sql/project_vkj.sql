CREATE DATABASE project_vkj;

CREATE USER 'dmzuser'@'7.7.7.2'
IDENTIFIED BY 'password123';

GRANT ALL PRIVILEGES
ON project_vkj.*
TO 'dmzuser'@'7.7.7.2';

FLUSH PRIVILEGES;