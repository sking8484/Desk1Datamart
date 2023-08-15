pub struct DataBaseUtils {
    pub db_user: String,
    pub db_password:String,
    pub db_host:String,
    pub db_port:u16,
    pub db_name:String
}

impl DataBaseUtils {
    pub fn new() -> DataBaseUtils {
        let db_user = env!("MYSQL_USER").to_string();
        let db_password = env!("MYSQL_PASSWORD").to_string();
        let db_host = env!("MYSQL_HOST").to_string();
        let db_port = env!("MYSQL_PORT").to_string();
        let db_name = env!("MYSQL_DBNAME").to_string();
        let db_port = db_port.parse().unwrap();

        return DataBaseUtils { db_user: db_user,
            db_password: db_password,
            db_host: db_host,
            db_port: db_port,
            db_name: db_name 
        }
    }
    pub fn get_conn_builder(&self) -> mysql::OptsBuilder {
        mysql::OptsBuilder::new()
            .ip_or_hostname(Some(&self.db_host))
            .tcp_port(self.db_port)
            .db_name(Some(&self.db_name))
            .user(Some(&self.db_user))
            .pass(Some(&self.db_password))

    }
}







