<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <!-- Quill CDN -->
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
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
        /* tr:nth-child(even){
            background-color: beige;
        } */
        input {
            width: 400px;
        }
        #editor {
            height: 400px;
            text-align: left;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>
            <table>
                <tr>
                    <th>작성자</th>
                    <td>{{info.userId}}</td>
                </tr>
                <tr>
                    <th>글제목</th>
                    <td><input v-model="title"></td>
                </tr>
                <tr>
                    <th>글내용</th>
                    <td><div id="editor"></div></td>
                </tr>
            </table>
            <div>
                <button @click="fnUpdate">수정</button>
                <button @click="fnBack">취소</button>
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
                info : {},
                bbsNum: "${bbsNum}",
                title : "",
                contents : "",
                quillInstance: null
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnBbsInfo: function () {
                let self = this;
                let param = {
                    bbsNum: self.bbsNum
                };
                $.ajax({
                    url: "/bbs/view.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.info = data.info;
                        self.title = data.info.title;
                        self.contents = data.info.contents;

                        // Quill 에디터에 기존 내용 설정
                        if (self.quillInstance) {
                            self.quillInstance.root.innerHTML = self.contents;
                        }
                    }
                });
            },
            fnUpdate: function() {
                let self = this;
                let param = {
                    bbsNum: self.bbsNum,
                    title: self.title,
                    contents: self.contents
                };
                $.ajax({
                    url: "/bbs/edit.dox", // 실제 수정 URL (컨트롤러에 구현 필요)
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function(data) {
                        alert("게시글이 수정되었습니다.");
                        pageChange("/bbs/view.do", {bbsNum : self.bbsNum});
                    }
                });
            },
            fnBack: function() {
                pageChange("/bbs/view.do", {bbsNum : this.bbsNum});
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            // Quill 에디터 초기화
            self.quillInstance = new Quill('#editor', {
                theme: 'snow',
                modules: {
                    toolbar: [
                        [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
                        ['bold', 'italic', 'underline'],
                        [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                        ['link', 'image'],
                        ['clean']
                    ]
                }
            });

            // 에디터 내용이 변경될 때마다 Vue 데이터를 업데이트
            self.quillInstance.on('text-change', function() {
                self.contents = self.quillInstance.root.innerHTML;
            });
            
            // 게시글 정보 불러오기
            self.fnBbsInfo();
        }
    });

    app.mount('#app');
</script>