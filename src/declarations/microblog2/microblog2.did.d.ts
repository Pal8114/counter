import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface Message {
  'content' : string,
  'time' : Time,
  'author' : string,
}
export type Time = bigint;
export interface _SERVICE {
  'follow' : ActorMethod<[Principal], undefined>,
  'follows' : ActorMethod<[], Array<Principal>>,
  'get_name' : ActorMethod<[], string>,
  'otherposts' : ActorMethod<[Principal, Time], Array<Message>>,
  'post' : ActorMethod<[string], undefined>,
  'posts' : ActorMethod<[Time], Array<Message>>,
  'set_name' : ActorMethod<[string], undefined>,
  'timeline' : ActorMethod<[Time], Array<Message>>,
  'unfollow' : ActorMethod<[Principal], undefined>,
}
