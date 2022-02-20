import consumer from "./consumer"

consumer.subscriptions.create({ channel: "QuestionsChannel" }, {
    connected: () => { console.log('Connected!') }
})
