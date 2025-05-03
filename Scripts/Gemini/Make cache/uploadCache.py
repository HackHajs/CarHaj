from google import genai
from google.genai import types
import io
import httpx

client = genai.Client(api_key="")

long_context_pdf_path = "https://cdn.discordapp.com/attachments/852189042552078356/1368157384031080448/Cupra_manual_compressed.pdf?ex=6817335b&is=6815e1db&hm=1d4d80339663b6e49294f504ab5449271ca245b6d5375a01aa52d0b0b9cb33bb&"

# Retrieve and upload the PDF using the File API
doc_io = "./Cupra_manual.pdf"

document = client.files.upload(
  file=doc_io,
  config=dict(mime_type='application/pdf'),
)

model_name = "gemini-1.5-flash"
system_instruction = "You are a car support rep, and you must help users know how to use the Cupra Tavascan"

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

# Generate content using the cached prompt and document
response = client.models.generate_content(
  model=model_name,
  contents="How do I park?",
  config=types.GenerateContentConfig(
    cached_content=cache.name
  ))

# (Optional) Print usage metadata for insights into the API call
print(f'{response.usage_metadata=}')

# Print the generated text
print('\n\n', response.text)