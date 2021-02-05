//칼럼의 수만큼 자동 colspan
var target = document.getElementsByTagName('th');
for (var i = 0; i < target.length; i++) {
	target[i].setAttribute('class', 'tbl_col');
}

var tbl_cols_array = document.getElementsByClassName("tbl_col");
var tbl_cols = tbl_cols_array.length;//칼럼 배열의 길이=칼럼 수

//총 칼럼의 수만큼 colspan 속성 지정
var noData = document.getElementById("noData");
if (noData != null) {
	noData.setAttribute("colspan", tbl_cols);
}