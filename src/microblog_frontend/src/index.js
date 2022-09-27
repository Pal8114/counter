import { microblog } from "../../declarations/microblog";
import { Principal } from "@dfinity/principal";

var page = 0;

var getTime = time => {
  var unixTimestamp = Number(time);
  const timeInSeconds = Math.floor(unixTimestamp / 1000000);
  const d = new Date(timeInSeconds);
  return `${d.getFullYear()}-${d.getMonth()+1}-${d.getDate()} ${d.getHours()}:${d.getMinutes()}:${d.getSeconds()}`;
}

var clear = posts_section => posts_section.replaceChildren([]);

var clearWithLoading = posts_section => {
  posts_section.replaceChildren([]);
  let loading = document.createElement("p");
  loading.innerText = "loading..."
  posts_section.appendChild(loading);
}

async function follow() {
  let follow_button = document.getElementById("follow");
  let input = document.getElementById("follow_input");
  if (0 < input.value.length) {
    let text = input.value;
    follow_button.disabled = true;
    var id = Principal.fromText(text);
    await microblog.follow(id);
    follow_button.disabled = false;
  }
}

async function set() {
  let set_button = document.getElementById("set");
  let input = document.getElementById("name_input");
  if (0 < input.value.length) {
    let text = input.value;
    set_button.disabled = true;
    await microblog.set_name(text);
    set_button.disabled = false;
  }
}

async function post() {
  if (0 != page) {
    page = 0;
    load_posts();
  }
  let text = document.getElementById("message").value;
  if (0 < text.length) {
    document.getElementById("post").disabled = true;
    await microblog.post(text);
    document.getElementById("post").disabled = false;
    document.getElementById("message").value = "";
    load_posts();
  }
}

async function timeline() {
  if (2 != page) {
    page = 2;
  }
  // clear
  let posts_section = document.getElementById("posts");
  clearWithLoading(posts_section);
  document.getElementById("timeline").disabled = true;
  let array = await microblog.timeline(0);
  document.getElementById("timeline").disabled = false;
  ref_posts_section(posts_section, array);
}

async function getName() {
  document.getElementById("name_input").value = await microblog.get_name();
}

async function otherName(id) {
  return await microblog.othername(id);
}

async function load_follows() {
  // 修改状态
  if (1 != page) {
    page = 1;
  }
  // clear
  let posts_section = document.getElementById("posts");
  clearWithLoading(posts_section);
  // request
  document.getElementById("follows").disabled = true;
  let follows = await microblog.follows();
  document.getElementById("follows").disabled = false;
  ref_follows_section(posts_section, follows);
}

async function load_posts() {
  if (0 === page) {
    let posts_section = document.getElementById("posts");
    clearWithLoading(posts_section);
    // request
    let posts = await microblog.posts(0);
    ref_posts_section(posts_section, posts);
  }
}

var ref_posts_section = (posts_section, messages) => {
  clear(posts_section);
  for (var i = 0; i < messages.length; i++) {
    let text = document.createElement("p");
    text.innerText = messages[i].text;
    let author = document.createElement("p");
    author.innerText =  messages[i].author + " " + getTime(messages[i].time);
    author.style.fontSize = 14 + 'px';
    let div = document.createElement("div");
    div.appendChild(text);
    div.appendChild(author);
    div.appendChild(document.createElement("HR"))
    posts_section.appendChild(div);
  }
}

var ref_follows_section = (posts_section, follows) => {
  clear(posts_section);
  for (var i = 0; i < follows.length; i++) {
    var principalId = follows[i];

    let author = document.createElement("button");
    author.innerText = "loading..." +  " (" + principalId.toText() + ")";
    author.onclick = async () => {
      if (3 != page) {
        page = 3;
      }
      // clear
      clearWithLoading(posts_section);
      let posts = await microblog.otherposts(principalId, 0);
      ref_posts_section(posts_section, posts);
    };
    posts_section.appendChild(author);
    // 异步加载名字
    otherName(follows[i]).then((value) => author.innerText = value + " (" + principalId.toText() + ")");
  }
}

function load() {
  document.getElementById("post").onclick = post;
  document.getElementById("set").onclick = set;
  document.getElementById("follow").onclick = follow;
  document.getElementById("follows").onclick = load_follows;
  document.getElementById("timeline").onclick = timeline;
  getName();
  load_posts();
}

window.onload = load
