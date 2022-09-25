import 'package:agent_dart/agent_dart.dart';

/// motoko/rust function of the Counter canister
/// see ./dfx/local/counter.did
abstract class MicroBlogMethod {
  /// use staic const as method name
  static const follow = "follow";
  static const follows = "follows";
  static const get_name = "get_name";
  static const otherposts = "otherposts";
  static const othername = "othername";
  static const post = "post";
  static const posts = "posts";
  static const set_name = "set_name";
  static const timeline = "timeline";
  static const unfollow = "unfollow";
  static const postsInt = "postsInt";
  static const timelineInt = "timelineInt";

  /// you can copy/paste from .dfx/local/canisters/counter/counter.did.js
  static final ServiceClass idl = IDL.Service({
    MicroBlogMethod.follow: IDL.Func([IDL.Principal], [], []),
    MicroBlogMethod.follows: IDL.Func([], [IDL.Vec(IDL.Principal)], ['query']),
    MicroBlogMethod.get_name: IDL.Func([], [IDL.Text], ['query']),
    MicroBlogMethod.othername: IDL.Func([IDL.Principal], [IDL.Text], []),
    MicroBlogMethod.otherposts: IDL.Func([
      IDL.Principal,
      IDL.Int
    ], [
      IDL.Vec(IDL.Record({
        'text': IDL.Text,
        'time': IDL.Int,
        'author': IDL.Text,
      }))
    ], []),
    MicroBlogMethod.post: IDL.Func([IDL.Text], [], []),
    MicroBlogMethod.posts: IDL.Func([
      IDL.Int
    ], [
      IDL.Vec(IDL.Record({
        'text': IDL.Text,
        'time': IDL.Int,
        'author': IDL.Text,
      }))
    ], [
      'query'
    ]),
    MicroBlogMethod.postsInt: IDL.Func([
      IDL.Int
    ], [
      IDL.Vec(IDL.Record({
        'text': IDL.Text,
        'time': IDL.Int,
        'author': IDL.Text,
      }))
    ], [
      'query'
    ]),
    MicroBlogMethod.set_name: IDL.Func([IDL.Text], [], []),
    MicroBlogMethod.timeline: IDL.Func([
      IDL.Int
    ], [
      IDL.Vec(IDL.Record({
        'text': IDL.Text,
        'time': IDL.Int,
        'author': IDL.Text,
      }))
    ], []),
    MicroBlogMethod.unfollow: IDL.Func([IDL.Principal], [], []),
  });
}

///
/// Counter class, with AgentFactory within
class MicroBlog {
  /// AgentFactory is a factory method that creates Actor automatically.
  /// Save your strength, just use this template
  AgentFactory? _agentFactory;

  /// CanisterCator is the actor that make all the request to Smartcontract.
  CanisterActor? get actor => _agentFactory?.actor;
  final String canisterId;
  final String url;

  MicroBlog({required this.canisterId, required this.url});

  // A future method because we need debug mode works for local developement
  Future<void> setAgent(
      {String? newCanisterId,
      ServiceClass? newIdl,
      String? newUrl,
      Identity? newIdentity,
      bool? debug}) async {
    _agentFactory ??= await AgentFactory.createAgent(
        canisterId: newCanisterId ?? canisterId,
        url: newUrl ?? url,
        idl: newIdl ?? MicroBlogMethod.idl,
        identity: newIdentity,
        debug: debug ?? true);
  }

  /// Call canister methods like this signature
  /// ```dart
  ///  CanisterActor.getFunc(String)?.call(List<dynamic>) -> Future<dynamic>
  /// ```

// static const checkPermissions = "checkPermissions";
//   static const follow = "follow";
//   static const follows = "follows";
//   static const get_name = "get_name";
//   static const otherposts = "otherposts";
//   static const post = "post";
//   static const posts = "posts";
//   static const set_name = "set_name";
//   static const timeline = "timeline";
//   static const unfollow = "unfollow";

  Future<void> post(String content) async {
    try {
      await actor?.getFunc(MicroBlogMethod.post)!([content]);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<dynamic, dynamic>>> posts(int time) async {
    try {
      var array = await actor?.getFunc(MicroBlogMethod.posts)!([time]);
      print(array);
      return array;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<dynamic, dynamic>>> otherposts(String id, int time) async {
    try {
      var array = await actor?.getFunc(MicroBlogMethod.otherposts)!(
          [Principal.fromText(id), time]);
      print(array);
      return array;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<dynamic, dynamic>>> timeline(int time) async {
    try {
      var array = await actor?.getFunc(MicroBlogMethod.timeline)!([time]);
      print(array);
      return array;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> follow(String id) async {
    try {
      await actor?.getFunc(MicroBlogMethod.follow)!([Principal.fromText(id)]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unfollow(String id) async {
    try {
      await actor?.getFunc(MicroBlogMethod.unfollow)!([Principal.fromText(id)]);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Principal>> follows() async {
    try {
      var array = await actor?.getFunc(MicroBlogMethod.follows)!([]);
      print(array);
      return array;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getName() async {
    try {
      var name = await actor?.getFunc(MicroBlogMethod.get_name)!([]);
      return name;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> otherName(String id) async {
    try {
      var name = await actor
          ?.getFunc(MicroBlogMethod.othername)!([Principal.fromText(id)]);
      return name;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setName(String name) async {
    try {
      await actor?.getFunc(MicroBlogMethod.set_name)?.call([name]);
    } catch (e) {
      rethrow;
    }
  }
}
