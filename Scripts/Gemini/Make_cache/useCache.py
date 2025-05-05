from google import genai
from google.genai import types
import io
import httpx

client = genai.Client(api_key="AIzaSyCxi987e4WEYQALikV8KwF8usDFp8ur2VA")


response = client.models.generate_content(
  model="gemini-2.0-flash",
  contents="How do I park?",
  config=types.GenerateContentConfig(
    cached_content="cachedContents/z0m9y6ik9v4g"
  ))

# (Optional) Print usage metadata for insights into the API call
print(f'{response.usage_metadata=}')

# Print the generated text
print('\n\n', response.text)
