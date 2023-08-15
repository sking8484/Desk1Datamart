use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
mod utils;


#[actix_web::main]
async fn main() -> std::io::Result<()> {

    let db_util = utils::db_utils::DataBaseUtils::new();
    let builder = db_util.get_conn_builder();

    let pool = mysql::Pool::new(builder).unwrap();
    let shared_data = web::Data::new(pool);
    
    HttpServer::new(move || {
        App::new()
            .app_data(shared_data.clone())
            .service(hello)
            .service(echo)
            .route("/hey", web::get().to(manual_hello))
    })
        .bind(("0.0.0.0", 8080))?
        .run()
        .await
}

#[get("/")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().body(env!("MYSQL_PASSWORD"))
}


#[post("/echo")]
async fn echo(req_body: String) -> impl Responder {
    HttpResponse::Ok().body(req_body)
}


async fn manual_hello() -> impl Responder {
    HttpResponse::Ok().body("Hey there guy!")
}



#[cfg(test)]
mod tests {
    use crate::utils;
    use mysql;
    use mysql::prelude::*;

    #[test]
    fn grab_env_variables() {
        println!("DB_PASSWORD IS: {}", env!("MYSQL_PASSWORD"))
    }


    #[test]
    fn test_create_table() {
        let db_util = utils::db_utils::DataBaseUtils::new();
        let builder = db_util.get_conn_builder();
        let pool = mysql::Pool::new(builder).unwrap();
        let mut conn = pool.get_conn().unwrap();
        conn.query_drop(
            r"CREATE TEMPORARY TABLE payment (
                customer_id int not null,
                amount int not null
            )"
        ).unwrap();





    }
}
