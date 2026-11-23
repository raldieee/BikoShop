const STORAGE_KEY = "bikoshop_products";

const sampleProducts = [
    { id: 1, name: "Classic Biko Slice", categoryId: "1", description: "Traditional sticky rice cake.", price: 45 },
    { id: 2, name: "Classic Biko Tray", categoryId: "1", description: "Family-size traditional biko.", price: 250 },
    { id: 3, name: "Ube Biko", categoryId: "2", description: "Biko with a delicious ube flavor.", price: 60 },
    { id: 4, name: "Pandan Biko", categoryId: "2", description: "Aromatic biko with pandan flavor.", price: 60 },
    { id: 5, name: "Mini Biko Box", categoryId: "3", description: "A small individual biko box.", price: 80 }
];

const categories = {
    "1": "Classic Biko",
    "2": "Flavored Biko",
    "3": "Biko Box",
    "4": "Gift Package"
};

function getProducts() {
    const saved = localStorage.getItem(STORAGE_KEY);

    if (saved === null) {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(sampleProducts));
        return [...sampleProducts];
    }

    try {
        const products = JSON.parse(saved);
        return Array.isArray(products) ? products : [...sampleProducts];
    } catch {
        return [...sampleProducts];
    }
}

function saveProducts(products) {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(products));
}

function formatPrice(price) {
    return Number(price).toLocaleString("en-PH", {
        style: "currency",
        currency: "PHP",
        minimumFractionDigits: 2
    });
}

function renderProducts(searchText = "") {
    const tableBody = document.getElementById("product-table-body");
    if (!tableBody) return;

    const products = getProducts();
    const query = searchText.trim().toLowerCase();

    const filteredProducts = products.filter(product => {
        const category = categories[product.categoryId] || "Uncategorized";
        return [product.id, product.name, category, product.description, product.price]
            .some(value => String(value ?? "").toLowerCase().includes(query));
    });

    const count = document.getElementById("product-count");
    if (count) {
        count.textContent = `${filteredProducts.length} product(s) shown`;
    }

    if (filteredProducts.length === 0) {
        tableBody.innerHTML = '<tr><td colspan="5" class="empty-state">No products found.</td></tr>';
        return;
    }

    tableBody.innerHTML = filteredProducts.map(product => `
        <tr>
            <td>${product.id}</td>
            <td>${escapeHTML(product.name)}</td>
            <td>${escapeHTML(categories[product.categoryId] || "Uncategorized")}</td>
            <td>${formatPrice(product.price)}</td>
            <td>
                <div class="action-group">
                    <a class="action-btn" href="form.html?id=${product.id}">Edit</a>
                    <button class="action-btn delete" type="button" data-delete-id="${product.id}">Delete</button>
                </div>
            </td>
        </tr>
    `).join("");
}

function escapeHTML(value) {
    return String(value).replace(/[&<>"']/g, character => ({
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "'": "&#039;"
    })[character]);
}

function setupListPage() {
    const searchInput = document.getElementById("product-search");
    const tableBody = document.getElementById("product-table-body");

    if (!tableBody) return;

    renderProducts();

    searchInput?.addEventListener("input", event => {
        renderProducts(event.target.value);
    });

    tableBody.addEventListener("click", event => {
        const deleteButton = event.target.closest("[data-delete-id]");
        if (!deleteButton) return;

        const productId = Number(deleteButton.dataset.deleteId);
        const confirmed = window.confirm("Are you sure you want to delete this product?");
        if (!confirmed) return;

        const updatedProducts = getProducts().filter(product => product.id !== productId);
        saveProducts(updatedProducts);
        renderProducts(searchInput?.value || "");
    });
}

function setupFormPage() {
    const form = document.getElementById("product-form");
    if (!form) return;

    const params = new URLSearchParams(window.location.search);
    const productId = Number(params.get("id"));
    const products = getProducts();
    const existingProduct = productId
        ? products.find(product => product.id === productId)
        : null;

    if (existingProduct) {
        document.getElementById("form-title").textContent = "Edit Product";
        document.getElementById("product-id").value = existingProduct.id;
        document.getElementById("product-name").value = existingProduct.name;
        document.getElementById("category-id").value = existingProduct.categoryId;
        document.getElementById("description").value = existingProduct.description || "";
        document.getElementById("unit-price").value = existingProduct.price;
    }

    form.addEventListener("submit", event => {
        event.preventDefault();

        const idValue = document.getElementById("product-id").value;
        const product = {
            id: idValue ? Number(idValue) : Math.max(0, ...products.map(item => item.id)) + 1,
            name: document.getElementById("product-name").value.trim(),
            categoryId: document.getElementById("category-id").value,
            description: document.getElementById("description").value.trim(),
            price: Number(document.getElementById("unit-price").value)
        };

        if (!product.name || !product.categoryId || !Number.isFinite(product.price) || product.price < 0) {
            alert("Please complete the required fields correctly.");
            return;
        }

        const latestProducts = getProducts();
        const existingIndex = latestProducts.findIndex(item => item.id === product.id);

        if (existingIndex >= 0) {
            latestProducts[existingIndex] = product;
        } else {
            latestProducts.push(product);
        }

        saveProducts(latestProducts);
        window.location.href = "list.html";
    });
}

document.addEventListener("DOMContentLoaded", () => {
    setupListPage();
    setupFormPage();
});
