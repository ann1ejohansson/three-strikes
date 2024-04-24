function openModal(imageSrc, captionText) {
  var modal = document.getElementById("myModal");
  var modalImg = document.getElementById("modalImage");
  var caption = document.getElementById("caption");
  modal.style.display = "block";
  modalImg.src = imageSrc;
  caption.innerHTML = captionText;
}

function closeModal() {
  var modal = document.getElementById("myModal");
  modal.style.display = "none";
}

var IndexValue = 1;
showImg(IndexValue);
