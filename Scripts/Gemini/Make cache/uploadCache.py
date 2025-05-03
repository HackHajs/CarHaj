from google import genai
from google.genai import types
import io
import httpx

client = genai.Client(api_key="")

# Retrieve and upload the PDF using the File API
doc_io = "./Cupra_manual.pdf"

document = client.files.upload(
  file=doc_io,
  config=dict(mime_type='application/pdf'),
)

model_name = "models/gemini-1.5-flash-001"
system_instruction = "You are a car support rep, and you must help users know how to use the Cupra Tavuscan"

# Create a cached content object
cache = client.caches.create(
    model=model_name,
    config=types.CreateCachedContentConfig(
      system_instruction=system_instruction,
      contents=[document],
    )
)

# Display the cache details
print(f'{cache=}')