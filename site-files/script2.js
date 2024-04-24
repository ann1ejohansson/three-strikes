var IndexValue = 1;
showImg(IndexValue);

function side_slide(e) {
  showImg (IndexValue +=e);
}

function showImg(e) {
  var i; 
  const img = document.querySelectorAll('.images img');
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
