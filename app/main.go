package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/gorilla/mux"
	"github.com/minio/minio-go/v7"
	"github.com/minio/minio-go/v7/pkg/credentials"
)

var minioClient *minio.Client

func main() {
	// Initialize MinIO client
	var err error
	minioClient, err = minio.New(os.Getenv("MINIO_ENDPOINT"), &minio.Options{
		Creds:  credentials.NewStaticV4(os.Getenv("MINIO_ACCESS_KEY"), os.Getenv("MINIO_SECRET_KEY"), ""),
		Secure: false,
	})
	if err != nil {
		log.Fatalln(err)
	}

	// Initialize router
	r := mux.NewRouter()
	r.HandleFunc("/hello", HelloHandler).Methods("GET")
	r.HandleFunc("/test/fetch", FetchFileHandler).Methods("GET")

	// Start server
	http.Handle("/", r)
	log.Println("Server started on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func HelloHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "world")
}

func FetchFileHandler(w http.ResponseWriter, r *http.Request) {
	object, err := minioClient.GetObject(r.Context(), "testbucket", "test.txt", minio.GetObjectOptions{})
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer object.Close()

	stat, err := object.Stat()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	http.ServeContent(w, r, stat.Key, stat.LastModified, object)
}
