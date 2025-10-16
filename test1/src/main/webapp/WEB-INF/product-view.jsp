<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
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
            <table>
                <tr>
                    <th>음식 이름</th>
                    <td>{{info.foodName}}</td>
                </tr>
                <tr>
                    <th>음식 설명</th>
                    <td>{{info.foodInfo}}</td>
                </tr>
                <tr>
                    <th>음식 가격</th>
                    <td>₩{{info.price}}</td>
                </tr>
                <tr>
                    <th>수량</th>
                    <td><input v-model="num"><button @click="fnPayment">주문하기</button></td>
                </tr>
                <tr>
                    <th>음식 사진</th>
                    <td>
                        <img v-for="item in fileList" :src="item.filePath">
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>

<script>
    IMP.init("imp30117516"); // 예: imp00000000
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                foodNo : "${foodNo}",
                sessionId : "${sessionId}",
                info : {},
                fileList : [],
                num : 1
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnProductInfo: function () {
                let self = this;
                let param = {
                    foodNo : self.foodNo
                };
                $.ajax({
                    url: "/product/view.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.info = data.info;
                        self.fileList = data.fileList;
                    }
                });
            },
            fnPayment : function() {
                let self = this;
                IMP.request_pay({
				    pg: "html5_inicis", // 포트원 관리자 콘솔 PG Provider
				    pay_method: "card",
				    merchant_uid: "merchant_" + new Date().getTime(),
				    name: self.info.foodName, // 제품 이름
				    amount: 100, // self.info.price * self.num // 테스트이므로 100원 결제로 진행
				    buyer_tel: "010-0000-0000",
				  }	, function (rsp) { // callback
			   	      if (rsp.success) {
			   	        // 결제 성공 시
						// alert("성공");
						console.log(rsp);
                        self.fnPayHistory(rsp.imp_uid, rsp.paid_amount);
			   	      } else {
			   	        // 결제 실패 시
                        console.error(rsp); // 실패 정보 확인을 위해 콘솔에 출력
                        alert("결제 실패: " + rsp.error_msg);
			   	      }
		   	  	});
            },
            fnPayHistory : function(uid, amount) {
                let self = this;
                let param = {
                    foodNo : self.foodNo,
                    uid : uid,
                    amount : amount,
                    userId : self.sessionId
                };
                $.ajax({
                    url: "/product/payment.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        if(data.result == "success") {
                            alert("결제되었습니다");
                        } else {
                            alert("오류가 발생했습니다");
                        }
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnProductInfo();
        }
    });

    app.mount('#app');
</script>