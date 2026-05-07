import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, DeleteCommand } from '@aws-sdk/lib-dynamodb';

const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);

export const handler = async (event: {
  pathParameters: { id: string };
}): Promise<{ statusCode: number; body: string }> => {
  try {
    console.log(
      JSON.stringify({
        level: 'INFO',
        function: 'deleteApplication',
        message: 'Request received',
        input: event.pathParameters,
      }),
    );
    await docClient.send(
      new DeleteCommand({
        TableName: process.env.TABLE_NAME,
        Key: { id: event.pathParameters.id },
      }),
    );
    console.log(
      JSON.stringify({
        level: 'INFO',
        function: 'deleteApplication',
        message: 'Application deleted successfully',
        input: event.pathParameters,
      }),
    );

    return {
      statusCode: 204,
      body: JSON.stringify({ message: 'Application deleted' }),
    };
  } catch (_error) {
    console.log(
      JSON.stringify({
        level: 'ERROR',
        function: 'deleteApplication',
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
