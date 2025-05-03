from google import genai
from google.genai import types
import httpx
client = genai.Client(api_key="AIzaSyCxi987e4WEYQALikV8KwF8usDFp8ur2VA")

doc_url = "https://cdn.discordapp.com/attachments/852189042552078356/1368157384031080448/Cupra_manual_compressed.pdf?ex=6817335b&is=6815e1db&hm=1d4d80339663b6e49294f504ab5449271ca245b6d5375a01aa52d0b0b9cb33bb&"

# Retrieve and encode the PDF byte
doc_data = httpx.get(doc_url).content

print("doc_uploaded")

prompt = "Summarize this document"
response = client.models.generate_content(
  model="gemini-2.0-flash",
  contents=[
      types.Part.from_bytes(
        data=doc_data,
        mime_type='application/pdf',
      ),
      prompt])
print(response.text)