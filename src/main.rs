use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
mod utils;


#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
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
    HttpResponse::Ok().body(env!("DB_PASSWORD"))
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
    #[test]
    fn grab_env_variables() {
        println!("DB_PASSWORD IS: {}", env!("DB_PASSWORD"))
    }
}
