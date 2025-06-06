// CropListPage.jsx
import React from 'react';
import { useNavigate } from 'react-router-dom';

const crops = [
  {
    id: 1,
    name: 'トマト',
    plantDate: '2025-01-10',
    note: '水やり注意',
    image: '/images/tomato.jpg',
  },
  {
    id: 2,
    name: 'キャベツ',
    plantDate: '2025-01-15',
    note: '害虫に注意',
    image: '/images/cabbage.jpg',
  },
];

export default function CropListPage() {
  const navigate = useNavigate();

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold mb-4">🌾 作物管理</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {crops.map(crop => (
          <div
            key={crop.id}
            className="bg-green-100 p-4 rounded shadow hover:bg-green-200 cursor-pointer"
            onClick={() => navigate(`/detail/${crop.id}`)}
          >
            <img src={crop.image} alt={crop.name} className="w-full h-32 object-cover rounded" />
            <h2 className="text-xl font-semibold mt-2">{crop.name}</h2>
            <p>植え付け日: {crop.plantDate}</p>
            <p className="text-sm text-green-800">{crop.note}</p>
          </div>
        ))}
      </div>
    </div>
  );
}