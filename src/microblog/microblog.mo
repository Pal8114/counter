import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Int = "mo:base/Int";
import Nat "mo:base/Nat";

module {
    
    public type Message = {
        text: Text;
        time: Time.Time;
        author: Text;
    };

    public type Microblog = actor {
        follow: shared(Principal) -> async(); // 关注
        unfollow: shared(Principal) -> async(); // 取关
        follows: shared query() -> async [Principal]; // 关注列表
        post: shared(Text) -> async(); // 发布
        posts: shared query(Time.Time) -> async [Message]; // 文章列表
        otherposts: shared query(Principal, Time.Time) -> async [Message]; // 指定id的文章列表
        timeline: shared(Time.Time) -> async [Message]; // 
        set_name: shared(Text) -> async(); // 设置自己的名字
        get_name: shared () -> async (Text); // 获取名字
    }

}