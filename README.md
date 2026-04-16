# 🎭 Deepfake Detection System

This project is an AI-powered system designed to detect deepfake videos by analyzing visual features and facial regions within video frames.  
It was developed as part of an academic graduation project to address the growing risks of deepfake media and provide a practical filtering solution.

---

## 📌 Overview

Deepfake content can threaten privacy, trust, and information security.  
Our system aims to automatically detect manipulated videos by analyzing faces, extracting features, and classifying content in real time.  
A key part of this project is implementing a **Deepfake Filter** that can be integrated into a user-facing mobile application to flag suspicious videos immediately.

<p align="center">
<img align="center" width="515" height="455" alt="image" src="https://github.com/user-attachments/assets/6ce3a705-c881-439a-8bb4-8c26ca4c1bb8" />
<p align="center">
<img width="591" height="398" alt="image" src="https://github.com/user-attachments/assets/d8eb6fef-f5e7-4b6d-b831-77a3b2bc3679" />
 <p align="center">
<img width="554" height="409" alt="image" src="https://github.com/user-attachments/assets/daba10dc-a99a-440c-a7d0-0ea95d8de923" />
</p>

---

## ⚙️ Key Features

- **Face Detection & Extraction:** Automatically detects and crops faces from video frames using OpenCV.
- **Deep Feature Extraction:** Uses a deep learning model (**Xception**) to analyze subtle visual patterns.
- **Real/Fake Classification:** Predicts the authenticity of faces and frames.
- **Video-Level Aggregation:** Combines frame-level results to classify entire videos.
- **Flask REST API:** Serves predictions for easy integration with other applications.
- **Mobile Filter Application:** Provides a practical **Deepfake Filter** that works through a mobile app (built with **Flutter**) to detect deepfake videos directly on user devices.

---

## 🧩 Tech Stack

- **Python**, **TensorFlow**, **Keras** — Model training and prediction
- **OpenCV** — Video processing & face extraction
- **Flask** — REST API for serving the detection model
- **Flutter** — Cross-platform mobile app implementing the Deepfake Filter
- **FaceForensics++** — Base dataset for training and evaluation

---

## 📂 Project Structure

---

## 🚀 How It Works

1️⃣ **Upload Video:** User uploads a video through the mobile app.  
2️⃣ **Frame Extraction:** The system splits the video into frames and extracts faces.  
3️⃣ **Prediction:** The AI model classifies each face as real or fake.  
4️⃣ **Filtering:** The **Deepfake Filter** aggregates predictions and shows the user a result in the app.  
5️⃣ **Response:** The user receives a clear score and recommendation (e.g., safe or suspicious content).

---

## 👥 Authors

- **Bahaa aldin Alzhouri**
- **Mahmut Basmaci**

Graduation Project — Firat Universitesy — 2025

---

## 🔗 References

- FaceForensics++ Dataset — [GitHub](https://github.com/ondyari/FaceForensics)
- Xception Model — [Paper](https://arxiv.org/abs/1610.02357)
- Flutter — [flutter.dev](https://flutter.dev/)

---

## 📄 License

This project is part of an academic study and is not intended for commercial use.  
Contact us for questions or possible collaboration.


