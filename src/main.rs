use axum::{
    routing::get,
    Json, Router,
};
use chrono::Utc;
use chrono_tz::Tz;
use serde::{Deserialize, Serialize};
use tower_http::services::ServeDir;

const DEFAULT_STATUS_STR: &str = "Nothing to see here...";

#[derive(Deserialize)]
struct LanyardResponse {
    data: Option<LanyardData>,
}

#[derive(Deserialize)]
struct LanyardData {
    activities: Option<Vec<Activity>>,
}

#[derive(Deserialize)]
struct Activity {
    #[serde(rename = "type")]
    activity_type: u8,
    state: Option<String>,
}

#[derive(Serialize)]
struct StatusResponse {
    status: String,
}

#[derive(Serialize)]
struct TimeResponse {
    time: String,
}

async fn lanyard() -> Json<StatusResponse> {
    let client = reqwest::Client::new();
    
    let status = fetch_discord_status(&client).await.unwrap_or_else(|| {
        DEFAULT_STATUS_STR.to_string()
    });

    Json(StatusResponse { status })
}

async fn fetch_discord_status(client: &reqwest::Client) -> Option<String> {
    let res = client
        .get("https://api.lanyard.rest/v1/users/1266754182082461751")
        .send()
        .await
        .ok()?;

    let lanyard_res = res.json::<LanyardResponse>().await.ok()?;
    let activities = lanyard_res.data?.activities?;

    let custom_activity = activities.iter().find(|act| act.activity_type == 4)?;
    let raw_state = custom_activity.state.as_ref()?;

    let trimmed = raw_state.trim();
    let cleaned = if trimmed.starts_with('"') && trimmed.ends_with('"') && trimmed.len() >= 2 {
        &trimmed[1..trimmed.len() - 1]
    } else {
        trimmed
    };

    if cleaned.is_empty() {
        None
    } else {
        Some(cleaned.to_string())
    }
}

async fn time() -> Json<TimeResponse> {
    let tz: Tz = "America/Chicago".parse().expect("Invalid timezone");
    let time_str = Utc::now().with_timezone(&tz).format("%H:%M").to_string();

    Json(TimeResponse { time: time_str })
}

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/api/lanyard", get(lanyard))
        .route("/api/time", get(time))
        .fallback_service(ServeDir::new("."));

    let listener = tokio::net::TcpListener::bind("127.0.0.1:7000")
        .await
        .unwrap();
    
    println!("Server is running on http://127.0.0.1:7000");
    
    axum::serve(listener, app).await.unwrap();
}