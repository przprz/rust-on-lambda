extern crate lambda_runtime as lambda;
extern crate log;
extern crate serde_derive;
extern crate simple_logger;

use std::error::Error;

use lambda::{Context, error::HandlerError, lambda};
use log::{error, debug};
use serde_derive::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
struct GreetingEvent {
    greeting: String,
    name: String,
}

#[derive(Serialize, Deserialize)]
struct GreetingResponse {
    message: String,
}

fn main() -> Result<(), Box<dyn Error>> {
    simple_logger::init_with_level(log::Level::Debug).unwrap();
    lambda!(howdy);

    Ok(())
}

fn howdy(event: GreetingEvent, ctx: Context) -> Result<GreetingResponse, HandlerError> {
    debug!("Received event: {:?}", event);
    if event.name == "" {
        error!("Empty name in request {}", ctx.aws_request_id);
        return Err(ctx.new_error("Empty name"));
    }

    Ok(GreetingResponse {
        message: format!("{}, {}!", event.greeting, event.name),
    })
}
