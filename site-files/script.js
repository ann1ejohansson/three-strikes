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
function side_slide(e) {
  showImg (indexValue +=e);
}
function showImg(e) {
  var i; 
  const img = document.querySelectorAll('img')
  if(e > img.length) {
    IndexValue = 1
  }
  if(e < 1) {
    IndexValue = img.length
  }
  for(i = 0; i < img.length; i++) {
    img[i].style.display = "none"; 
  }
  img[IndexValue - 1].style.display = "block"; 
    
    
