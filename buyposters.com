import React from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { useState } from "react";

const products = [
  {
    id: 1,
    title: "Nature Poster",
    type: "Poster",
    price: 5,
    previewUrl: "/previews/nature-low.jpg",
    downloadUrl: "/downloads/nature-high.jpg",
    watermark: true
  },
  {
    id: 2,
    title: "Motivational Video",
    type: "Video",
    price: 10,
    previewUrl: "/previews/motivation-low.mp4",
    downloadUrl: "/downloads/motivation-high.mp4",
    watermark: true
  },
  {
    id: 3,
    title: "Inspirational Video",
    type: "Video",
    price: 8,
    previewUrl: "/previews/inspiration-low.mp4",
    downloadUrl: "c:\Users\USER\Downloads\JPG.mp4",
    watermark: true
  }
];

export default function DigitalStore() {
  const [user, setUser] = useState(null);
  const [request, setRequest] = useState("");

  const handleLogin = () => setUser({ name: "Dionis" });
  const handleLogout = () => setUser(null);
  const handlePurchase = (productId) => alert(`Purchased product ${productId}`);
  const handleRequestSubmit = () => {
    if (!request.trim()) return;
    alert(`Request submitted: ${request}`);
    setRequest("");
  };

  return (
    <div className="p-6 grid grid-cols-1 md:grid-cols-2 gap-6">
      <div className="col-span-full flex justify-between items-center">
        <h1 className="text-3xl font-bold">Digital Product Store</h1>
        {user ? (
          <div className="flex items-center gap-4">
            <span>Welcome, {user.name}</span>
            <Button onClick={handleLogout}>Logout</Button>
          </div>
        ) : (
          <div className="flex items-center gap-2">
            <Input placeholder="Username" />
            <Button onClick={handleLogin}>Login</Button>
          </div>
        )}
      </div>

      {products.map((product) => (
        <Card key={product.id} className="rounded-2xl shadow-lg">
          <CardContent className="p-4">
            <h2 className="text-xl font-semibold mb-2">{product.title}</h2>
            {product.type === "Poster" ? (
              <img
                src={product.previewUrl}
                alt={product.title}
                className="w-full rounded mb-2 border border-gray-300"
              />
            ) : (
              <video
                controls
                src={product.previewUrl}
                className="w-full rounded mb-2 border border-gray-300"
              />
            )}
            <p className="text-gray-600 mb-2">Price: ${product.price}</p>
            <Button onClick={() => handlePurchase(product.id)}>
              Buy & Download
            </Button>
            <p className="text-sm text-gray-400 mt-2">
              * Preview shown with watermark & reduced quality.
            </p>
          </CardContent>
        </Card>
      ))}

      <div className="col-span-full mt-6">
        <h2 className="text-2xl font-bold mb-2">Request a Custom Product</h2>
        <Textarea
          placeholder="Describe what kind of poster or video you want me to create for you..."
          value={request}
          onChange={(e) => setRequest(e.target.value)}
          className="w-full mb-2"
        />
        <Button onClick={handleRequestSubmit}>Submit Request</Button>
      </div>
    </div>
  );
}
