using SqlHelper.Factories.DbData;
using SqlHelper.Factories.DefaultTypeValue;
using SqlHelper.Factories.SqlQuery;
using SqlHelper.Factories.TableAlias;
using SqlHelper.Helpers;
using SqlHelper.Output;
using SqlHelper.Paths;
using SqlHelper.UserInterface.Parameters;
using SqlHelper.UserInterface.Path;

namespace SqlHelper
{
    public class Program
    {
        private class Solution
        {
            private readonly IDbDataFactory _dbDataFactory;
            private readonly IPathFinder _pathFinder;
            private readonly ISqlQueryFactory _sqlQueryFactory;
            private readonly IParameterUserInterface _parameterUserInterface;
            private readonly IPathUserInterface _pathUserInterface;
            private readonly IOutputHandler _outputHandler;

            public Solution(
                IDbDataFactory dbDataFactory,
                IPathFinder pathFinder,
                ISqlQueryFactory sqlQueryFactory,
                IParameterUserInterface parameterUserInterface,
                IPathUserInterface pathUserInterface,
                IOutputHandler outputHandler)
            {
                _dbDataFactory = dbDataFactory;
                _pathFinder = pathFinder;
                _sqlQueryFactory = sqlQueryFactory;
                _parameterUserInterface = parameterUserInterface;
                _pathUserInterface = pathUserInterface;
                _outputHandler = outputHandler;
            }

            public void Solve()
            {
                var data = _dbDataFactory.Create();

                var parameters = _parameterUserInterface.GetParameters(data);
                
                var tables = parameters.Tables
                    .Select(table => table.Id)
                    .Union(parameters.Filters.Select(filter => filter.TableId))
                    .ToList();

                var paths = _pathFinder.Help(data, tables);

                if (paths.Any() == false)
                {
                    Console.Write("No output to generate!");
                    return;
                }
                var path = paths.Count() == 1 ?
                    paths.First() :
                    _pathUserInterface.Choose(paths);
                
                var output = _sqlQueryFactory.Generate(data, path, parameters);
                _outputHandler.Handle(output);
            }
        }

        static void Main(string[] args)
        {
            IDbDataFactory dbDataFactory = new LocalSqlExpressDbDataFactory(args[0]);

            IPathFinder pathFinder = new MoveToBetterPathFinder();

            ISqlQueryFactory sqlQueryFactory = new MoveToBetterPrettierSqlQueryFactory(
                new FullyQualifiedTableAliasFactory(),
                new FirstDefaultTypeValueFactory(),
                padding: 5);

            IParameterUserInterface parameterUserInterface = new FirstParameterUserInterface(new ConsoleStream());

            IPathUserInterface pathUserInterface = new MoveToBetterPathUserInterface(new ConsoleStream());

            IOutputHandler outputHandler = new PrintToConsoleOutputHandler(new ConsoleStream());

            var solution = new Solution(
                dbDataFactory,
                pathFinder,
                sqlQueryFactory,
                parameterUserInterface,
                pathUserInterface,
                outputHandler);

            solution.Solve();
        }
    }
}