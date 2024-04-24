var currentIndex = 0;
var images = document.querySelectorAll(".gallery-item img");

function openModalWithIndex(index) {
  currentIndex = index;
  var image = images[index];
  openModal(image.src, image.alt);
}

function prevImage() {
  currentIndex = (currentIndex - 1 + images.length) % images.length;
  openModalWithIndex(currentIndex);
}

function nextImage() {
  currentIndex = (currentIndex + 1) % images.length;
  openModalWithIndex(currentIndex);
}
