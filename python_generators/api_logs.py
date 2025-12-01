from faker import Faker
import random, json, pandas as pd

fake = Faker()

# Génération clickstream
def generate_clickstream(n_events):
    events = []
    for i in range(n_events):
        events.append({
            "event_id": i + 1,
            "customer_id": random.randint(1, 5000000),
            "event_time": fake.date_time_between(start_date="-30d", end_date="now").isoformat(),
            "event_data": {
                "page": random.choice(["home","products","cart","checkout"]),
                "device": random.choice(["mobile","desktop","tablet"]),
                "duration_seconds": random.randint(5,300),
                "browser": random.choice(["Chrome","Safari","Firefox","Edge"]),
                "os": random.choice(["iOS","Android","Windows","MacOS","Linux"]),
                "session_id": fake.uuid4()
            }
        })
    with open("clickstream_events.jsonl","w") as f:
        for ev in events:
            f.write(json.dumps(ev) + "\n")

# Génération reviews
def generate_reviews(n_reviews):
    reviews = []
    for i in range(n_reviews):
        reviews.append({
            "review_id": i + 1,
            "product_id": random.randint(1, 3000),
            "rating": random.randint(1, 5),
            "review_date": fake.date_time_between(start_date="-60d", end_date="now").date().isoformat(),
            "review_data": {
                "comment": random.choice(["Bon produit","Moyen","Excellent","Pas satisfait"]),
                "language": random.choice(["fr","en","es"])
            }
        })
    pd.DataFrame(reviews).to_csv("product_reviews.csv", index=False)

if __name__ == "__main__":
    generate_clickstream(200000)
    generate_reviews(20000)
