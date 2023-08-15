pub struct DataBaseUtils {
    db_user: String,
    db_password:String,
    db_host:String,
    db_port:u16,
    db_name:String
}

impl DataBaseUtils {
    fn new() -> DataBaseUtils {
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
}


fn get_conn_builder(
    db_user: String,
    db_password: String,
    db_host: String,
    db_port: u16,
    db_name: String,
) -> mysql::OptsBuilder {
    mysql::OptsBuilder::new()
        .ip_or_hostname(Some(db_host))
        .tcp_port(db_port)
        .db_name(Some(db_name))
        .user(Some(db_user))
        .pass(Some(db_password))
}




