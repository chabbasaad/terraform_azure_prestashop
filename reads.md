 az containerapp exec --name prestashop-dev --resource-group rg-taylor-shift-dev --command "/bin/bash" 


 to connect to container for exuste install rm and move folder admin for change name


 or 

 $ rm -rf /var/www/html/var/cache/* && service apache2 reload

 to see users in database to verify conncetion : mysql -h ts-db-dev-v7gshw6i.mysql.database.azure.com -u tayloradmin -p'TaylorShift2025!Dev' prestashop -e "SELECT id_employee, email, firstname, lastname, active FROM lz794_employee WHERE active = 1;"