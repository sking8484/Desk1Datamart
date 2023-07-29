use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};


#[get("/")]
async fn hello() -> impl Resonder {
    HttpResponse::Ok().body("Hello world")
}


#[post("/echo")]
async fn echo(req_body: String) -> impl Responder {
    HttpResponse::Ok().body(req_body)
}


async fn manual_hello() -> impl Responder {
    HttpResponse::Ok().body("Hey there!")
}
