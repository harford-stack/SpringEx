<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: burlywood;
        }
        tr:nth-child(even){
            background-color: beige;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>
            <div>
                음식 종류 :
                <select v-model="selectMenuName">
                    <option value="">:: 선택 ::</option>
                    <option value="10">한식</option>
                    <option value="20">중식</option>
                    <option value="30">양식</option>
                    <option value="40">음료</option>
                    <option value="50">디저트</option>
                </select>
            </div>
            <table>
                <tr>
                    <th>음식 이름</th>
                    <td><input v-model="foodName"></td>
                </tr>
                <tr>
                    <th>음식 설명</th>
                    <td><input v-model="foodInfo"></td>
                </tr>
                <tr>
                    <th>음식 가격</th>
                    <td><input v-model="price"></td>
                </tr>
                <tr>
                    <th>음식 이미지</th>
                    <td><input type="file" id="file1" name="file1" accept=".jpg, .png"></td>
                </tr>
            </table>
            <div>
                <button @click="fnAdd">저장</button>
                <button @click="fnBack">되돌아가기</button>
            </div>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                selectMenuName : "",
                foodName : "",
                foodInfo : "",
                price : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnAdd: function () {
                let self = this;
                let param = {
                    selectMenuName : self.selectMenuName,
                    foodName : self.foodName,
                    foodInfo : self.foodInfo,
                    price : self.price
                };
                $.ajax({
                    url: "/product/add.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("등록되었습니다");
                        console.log(data.boardNo);
                        var form = new FormData();
                        form.append( "file1",  $("#file1")[0].files[0] );
                        form.append( "boardNo",  data.boardNo);
                        self.upload(form);  
                        // self.fnBack();
                    }
                });
            },
            fnUpload : function(form){
                var self = this;
                $.ajax({
                    url : "/fileUpload.dox"
                    , type : "POST"
                    , processData : false
                    , contentType : false
                    , data : form
                    , success:function(response) { 
                        console.log(data);
                    }	           
                });
            },
            fnBack: function() {
                location.href="product.do";
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>