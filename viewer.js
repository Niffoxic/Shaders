async function loadShaders() {
  const statusEl = document.getElementById("status");
  const gridEl = document.getElementById("grid");

  try {
    const res = await fetch("shaders.json", { cache: "no-store" });
    if (!res.ok) {
      throw new Error(`HTTP ${res.status}`);
    }

    const shaders = await res.json();

    if (!Array.isArray(shaders) || shaders.length === 0) {
      statusEl.textContent = "No shaders found in shaders.json.";
      return;
    }

    statusEl.textContent = `Found ${shaders.length} shader screenshot(s).`;

    shaders.forEach(shader => {
      const card = document.createElement("div");
      card.className = "card";

      // Preview image
      const img = document.createElement("img");
      img.src = shader.image;
      img.alt = shader.title || shader.name || "Shader screenshot";

      // Card body
      const body = document.createElement("div");
      body.className = "card-body";

      // Title
      const title = document.createElement("div");
      title.className = "card-title";
      title.textContent = shader.title || shader.name || "(untitled shader)";
      body.appendChild(title);

      // Optional group (folder name)
      if (shader.group && shader.group.length > 0) {
        const group = document.createElement("div");
        group.className = "card-group";
        group.textContent = shader.group;
        body.appendChild(group);
      }

      // Links
      const links = document.createElement("div");
      links.className = "card-links";

      if (shader.shader) {
        const linkShader = document.createElement("a");
        linkShader.href = shader.shader;
        linkShader.textContent = "View HLSL";
        linkShader.target = "_blank";
        links.appendChild(linkShader);
      }

      if (shader.image) {
        const linkRaw = document.createElement("a");
        linkRaw.href = shader.image;
        linkRaw.textContent = "Open image";
        linkRaw.target = "_blank";
        links.appendChild(linkRaw);
      }

      body.appendChild(links);
      card.appendChild(img);
      card.appendChild(body);
      gridEl.appendChild(card);
    });
  } catch (err) {
    console.error(err);
    statusEl.textContent = "Failed to load shaders.json. Check console/logs.";
  }
}

loadShaders();
