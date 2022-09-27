export const idlFactory = ({ IDL }) => {
  const Time = IDL.Int;
  const Message = IDL.Record({
    'content' : IDL.Text,
    'time' : Time,
    'author' : IDL.Text,
  });
  return IDL.Service({
    'follow' : IDL.Func([IDL.Principal], [], []),
    'follows' : IDL.Func([], [IDL.Vec(IDL.Principal)], ['query']),
    'get_name' : IDL.Func([], [IDL.Text], ['query']),
    'otherposts' : IDL.Func([IDL.Principal, Time], [IDL.Vec(Message)], []),
    'post' : IDL.Func([IDL.Text], [], []),
    'posts' : IDL.Func([Time], [IDL.Vec(Message)], ['query']),
    'set_name' : IDL.Func([IDL.Text], [], []),
    'timeline' : IDL.Func([Time], [IDL.Vec(Message)], []),
    'unfollow' : IDL.Func([IDL.Principal], [], []),
  });
};
export const init = ({ IDL }) => { return []; };
