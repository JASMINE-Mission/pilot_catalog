-- create another role
CREATE ROLE jasmine_user WITH ENCRYPTED PASSWORD 'jasmine';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO jasmine_user;

-- create another user
CREATE USER jasmine WITH ENCRYPTED PASSWORD 'jasmine';
GRANT jasmine_user TO jasmine;
