﻿using SqlHelper.Paths;

namespace SqlHelper.UserInterface.Path
{
    public interface IPathUserInterface
    {
        public ResultRouteTree Choose(IEnumerable<ResultRouteTree> paths);
    }
}
