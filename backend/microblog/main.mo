import Array "mo:base/Iter";
import Debug "mo:base/Debug";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Microblog "./microblog";
import Qs "./Qs";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Blob "mo:base/Blob";

actor {
  stable var get_principal = "bsm6x-7l3bz-cy7vb-lm7f5-ei5vi-2edut-h4m5o-bicgu-54cea-kozeu-jqe";
  stable var get_canister = "wqfjv-niaaa-aaaam-aas6a-cai"; // candid - ui post验证临时使用
  
  stable var followed : List.List<Principal> = List.nil(); 
  stable var messages : List.List<Microblog.Message> = List.nil(); 

  stable var whoami : Text = "No.17";
  
  // https://forum.dfinity.org/t/is-there-any-address-0-equivalent-at-dfinity-motoko/5445/3
  let null_address : Principal = Principal.fromText("aaaaa-aa");

  public shared func follow(id: Principal) : async () {
    if (id != null_address and null == List.find(followed, func(e : Principal) : Bool { e == id })) {
      followed := List.push(id, followed);
    }
  };

  public shared func unfollow(id: Principal) : async () {
    if (id != null_address) {
      followed := List.filter(followed, func(e : Principal) : Bool { e != id });
    }
  };

  public shared query func follows() : async [Principal] {
    List.toArray(followed)
  };

  public shared (msg) func post(text: Text) : async () {
    // let caller = Principal.toText(msg.caller);
    // // candid - ui post验证临时使用
    // if (Text.size(caller) == Text.size(get_principal)) {
    //   assert(Text.equal(caller, get_principal)); 
    // } else if (Text.size(caller) == Text.size(get_canister)) {
    //   assert(Text.equal(caller, get_canister)); // candid - ui post验证临时使用
    // };
    checkPermissions(Principal.toText(msg.caller));
    messages := List.push(
      {
        text = text; 
        time = Time.now();
        author = whoami;
      }, messages);
  };
  
  public shared query func posts(time: Time.Time) : async [Microblog.Message] {
    var filter : List.List<Microblog.Message> = List.nil(); 
    for (message in Iter.fromList(messages)) {
      if (message.time > time) {
        filter := List.push(message, filter);
      }
    };
    filter := List.reverse(filter);
    List.toArray(filter);
  };

  public shared query func postsInt(time: Int) : async [Microblog.Message] {
    var filter : List.List<Microblog.Message> = List.nil(); 
    for (message in Iter.fromList(messages)) {
      if (message.time > time) {
        filter := List.push(message, filter);
      }
    };
    filter := List.reverse(filter);
    List.toArray(filter);
  };

  public shared func otherposts(id: Principal, time: Time.Time) : async [Microblog.Message] {
    var other : List.List<Microblog.Message> = List.nil(); 
    if (id != null_address and null != List.find(followed, func(e : Principal) : Bool { e == id })) {
      let canister : Microblog.Microblog = actor(Principal.toText(id));
      let msgs = await canister.posts(time);
      for (message in Iter.fromArray(msgs)) {
        if (message.time > time) {
          other := List.push(message, other);
        }
      };
    };
    List.toArray(other);
  };

  public shared func othername(id: Principal) : async (Text) {
    var name = "not found";
    if (id != null_address and null != List.find(followed, func(e : Principal) : Bool { e == id })) {
      let canister : Microblog.Microblog = actor(Principal.toText(id));
      name := await canister.get_name();
    };
    name;
  };

  public shared func timeline(time: Time.Time) : async [Microblog.Message] {
    var all : List.List<Microblog.Message> = List.nil(); 
    for (id in Iter.fromList(followed)) {
      let canister : Microblog.Microblog = actor(Principal.toText(id));
      let msgs = await canister.posts(time);
      for (message in Iter.fromArray(msgs)) {
        if (message.time > time) {
          all := List.push(message, all);
        }
      };
    };
    
    var array:[var Microblog.Message] = List.toVarArray(all);
    var temp : List.List<Microblog.Message> = List.fromArray(Qs.quicksort(array));
    temp := List.reverse(temp);
    List.toArray(temp)
  };

  public shared query func get_name() : async (Text) {
    whoami
  };

  public shared(msg) func set_name(author: Text) : async () {
    // candid - ui post验证临时使用
    checkPermissions(Principal.toText(msg.caller));
    whoami := author;
  };

  // 检查权限
  func checkPermissions(caller: Text) : () {
    if (Text.size(caller) == Text.size(get_principal)) {
      assert(Text.equal(caller, get_principal)); 
    } else if (Text.size(caller) == Text.size(get_canister)) {
      assert(Text.equal(caller, get_canister)); // candid - ui post验证临时使用
    }
  }

};
