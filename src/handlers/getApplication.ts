import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, GetCommand } from '@aws-sdk/lib-dynamodb';

const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);

export const handler = async (event: {
  pathParameters: { id: string };
}): Promise<{
  statusCode: number;
  body: string;
}> => {
  try {
    console.log(
      JSON.stringify({
        level: 'INFO',
        function: 'getApplication',
        message: 'Request received',
        input: event.pathParameters,
      }),
    );
    const result = await docClient.send(
      new GetCommand({
        TableName: process.env.TABLE_NAME,
        Key: {
          id: event.pathParameters.id,
        },
      }),
    );

    if (!result.Item) {
      console.log(
        JSON.stringify({
          level: 'ERROR',
          function: 'getApplication',
          message: 'Application not found',
          input: event.pathParameters,
        }),
      );
      return {
        statusCode: 404,
        body: JSON.stringify({ message: 'Application not found' }),
      };
    }

    console.log(
      JSON.stringify({
        level: 'INFO',
        function: 'getApplication',
        message: 'Application retrieved successfully',
        input: event.pathParameters,
      }),
    );

    return {
      statusCode: 200,
      body: JSON.stringify(result.Item),
    };
  } catch (_error) {
    console.log(
      JSON.stringify({
        level: 'ERROR',
        function: 'getApplication',
        error: (_error as Error).message,
        input: event.pathParameters,
      }),
    );
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Internal server error' }),
    };
  }
};
