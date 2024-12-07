# Install model using : pip install -U sentence-transformers

from sentence_transformers import SentenceTransformer, util
import pandas as pd
from flask import Flask
from flask import request

# Returns a tuple of (shelf life, shelf life metric) given food name query string
def get_shelf_life_data(query):

    shelflife_data = pd.read_excel('FoodKeeper-Data.xls', sheet_name="Product", header=0, index_col=False, keep_default_na=True)
    all_keywords = shelflife_data["Keywords"]

    #Load the model
    model = SentenceTransformer('SeyedAli/Multilingual-Text-Semantic-Search-Siamese-BERT-V1')

    #Encode query and documents
    query_emb = model.encode(query)
    doc_emb = model.encode(all_keywords)

    #Compute dot score between query and all document embeddings
    scores = util.dot_score(query_emb, doc_emb)[0].cpu().tolist()

    #Combine docs & scores
    doc_score_pairs = list(zip(all_keywords, scores))

    #Sort by decreasing score
    doc_score_pairs = sorted(doc_score_pairs, key=lambda x: x[1], reverse=True)[0:5]

    #Output passages & scores
    print("Query: ", query)
    print("Top Matches")
    for doc, score in doc_score_pairs:
        print(score, doc)

    matched_row = shelflife_data.loc[shelflife_data['Keywords'] == doc_score_pairs[0][0]]
    closest_product_name = matched_row.iloc[0]["Name"]
    similarity_percentage = doc_score_pairs[0][1]

    # All possible ways to store and their life, ranked priority of refridgerated, pantry, freezer 
    dop_ref_life = matched_row.iloc[0]["DOP_Refrigerate_Max"]
    dop_ref_metric = matched_row.iloc[0]["DOP_Refrigerate_Metric"]

    ref_life = matched_row.iloc[0]["Refrigerate_Max"]
    ref_metric = matched_row.iloc[0]["Refrigerate_Metric"]

    ref_after_opening_life = matched_row.iloc[0]["Refrigerate_After_Opening_Max"]
    ref_after_opening_metric = matched_row.iloc[0]["Refrigerate_After_Opening_Metric"]

    ref_after_thawing_life = matched_row.iloc[0]["Refrigerate_After_Thawing_Max"]
    ref_after_thawing_metric = matched_row.iloc[0]["Refrigerate_After_Thawing_Metric"]

    dop_pant_life = matched_row.iloc[0]["DOP_Pantry_Max"]
    dop_pant_metric = matched_row.iloc[0]["DOP_Pantry_Metric"]

    pant_life = matched_row.iloc[0]["Pantry_Max"]
    pant_metric = matched_row.iloc[0]["Pantry_Metric"]

    dop_freeze_life = matched_row.iloc[0]["DOP_Freeze_Max"]
    dop_freeze_metric = matched_row.iloc[0]["DOP_Freeze_Metric"]

    freeze_life = matched_row.iloc[0]["Freeze_Max"]
    freeze_metric = matched_row.iloc[0]["Freeze_Metric"]

    if not pd.isna(dop_ref_life):
        return [str(dop_ref_life), str(dop_ref_metric), "DOP Fridge Life", closest_product_name, similarity_percentage]
    elif not pd.isna(ref_life):
        return [str(ref_life), str(ref_metric), "Fridge Life", closest_product_name, similarity_percentage]
    elif not pd.isna(ref_after_opening_life):
        return [str(ref_after_opening_life), str(ref_after_opening_metric), "Refridgerate After Opening Life", closest_product_name, similarity_percentage]
    elif not pd.isna(ref_after_thawing_life):
        return [str(ref_after_thawing_life), str(ref_after_thawing_metric), "Refridgerate After Thawing Life", closest_product_name, similarity_percentage]
    elif not pd.isna(dop_pant_life):
        return [str(dop_pant_life), str(dop_pant_metric), "DOP Pantry Life", closest_product_name, similarity_percentage]
    elif not pd.isna(pant_life):
        return [str(pant_life), str(pant_metric), "Pantry Life", closest_product_name, similarity_percentage]
    elif not pd.isna(dop_freeze_life):
        return [str(dop_freeze_life), str(dop_freeze_metric), "DOP Freezer Life", closest_product_name, similarity_percentage]
    elif not pd.isna(freeze_life):
        return [str(freeze_life), str(freeze_metric), "Freezer Life Found", closest_product_name, similarity_percentage]
    else:
        return ["NA", "NA", "Error: No shelf life values found", "NA", "NA"]

app = Flask(__name__)

@app.route("/getShelfLife")
def get_shelf_life():
    product_name = request.args.get('product_name')
    shelf_life_data = get_shelf_life_data(product_name)
    shelf_life = shelf_life_data[0]
    shelf_life_metric = shelf_life_data[1]
    shelf_life_type = shelf_life_data[2]
    closest_product_name = shelf_life_data[3]
    similarity_percentage = shelf_life_data[4]

    return {
        "length": shelf_life,
        "metric": shelf_life_metric,
        "life_type" : shelf_life_type,
        "closest_product_name": closest_product_name,
        "similarity_percentage": similarity_percentage
    }

app.run(host="0.0.0.0", port=5000)