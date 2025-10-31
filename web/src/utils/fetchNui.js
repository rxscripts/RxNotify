export default async function fetchNui(event, data = {}) {
  try {
    const resourceName = GetParentResourceName();

    const response = await fetch(`https://${resourceName}/${event}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: JSON.stringify(data),
    });

    if (!response.ok) {
      throw new Error(`Unable to fetch ${event}! Status: ${response.status}`);
    }

    return await response.json();
  } catch (error) {
    console.error(`API Error (${event}):`, error);
    return null;
  }
}
