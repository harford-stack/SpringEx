<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-3.7.1.js" 
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" 
        crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <title>Gemini 챗봇</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .chat-container {
            width: 350px;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
        }
        .chat-header {
            background: #007bff;
            color: white;
            padding: 15px;
            text-align: center;
            font-weight: bold;
        }
        .chat-box {
            height: 400px;
            overflow-y: auto;
            padding: 15px;
            display: flex;
            flex-direction: column;
        }
        .message {
            max-width: 70%;
            padding: 10px;
            border-radius: 10px;
            margin-bottom: 10px;
        }
        .user {
            align-self: flex-end;
            background: #007bff;
            color: white;
        }
        .bot {
            align-self: flex-start;
            background: #e9ecef;
        }
        .chat-input {
            display: flex;
            padding: 10px;
            border-top: 1px solid #ccc;
            background: white;
        }
        .chat-input textarea {
            flex: 1;
            height: 40px;
            border: none;
            resize: none;
            padding: 10px;
            border-radius: 5px;
            outline: none;
        }
        .chat-input button {
            margin-left: 10px;
            padding: 10px 15px;
            background: #007bff;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div id="app" class="chat-container">
        <div class="chat-header">Gemini 챗봇</div>
        <div class="chat-box" ref="chatBox">
            <div v-for="msg in messages" :class="['message', msg.type]">
                {{ msg.text }}
            </div>
        </div>
        <div class="chat-input">
            <textarea v-model="userInput" placeholder="메시지를 입력하세요..."></textarea>
            <button @click="sendMessage">전송</button>
        </div>
    </div>
</body>
<script>
    const app = Vue.createApp({
        data() {
            return {
                userInput: "",
                messages: []
            };
        },
        methods: {
            sendMessage() {
                if (this.userInput.trim() === "") return;
                
                this.messages.push({ text: this.userInput, type: 'user' });
                let inputText = this.userInput;
                this.userInput = "";
                this.scrollToBottom();
                
                $.ajax({
                    url: "/gemini/chat",
                    type: "GET",
                    data: { input: inputText },
                    success: (response) => {
                        this.messages.push({ text: response, type: 'bot' });
                        this.scrollToBottom();
                    },
                    error: (xhr) => {
                        this.messages.push({ text: "오류 발생: " + xhr.responseText, type: 'bot' });
                        this.scrollToBottom();
                    }
                });
            },
            scrollToBottom() {
                this.$nextTick(() => {
                    const chatBox = this.$refs.chatBox;
                    chatBox.scrollTop = chatBox.scrollHeight;
                });
            }
        }
    });
    app.mount('#app');
</script>
</html>