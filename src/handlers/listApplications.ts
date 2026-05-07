import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, ScanCommand } from '@aws-sdk/lib-dynamodb';

const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);

export const handler = async (): Promise<{
  statusCode: number;
  body: string;
}> => {
  try {
    console.log(
      JSON.stringify({
        level: 'INFO',
        function: 'listApplications',
        message: 'Request received',
      }),
    );
    const result = await docClient.send(
      new ScanCommand({
        TableName: process.env.TABLE_NAME,
        ProjectionExpression: 'id, company, #position, #status, date_applied',
        ExpressionAttributeNames: {
          '#position': 'position',
          '#status': 'status',
        },
      }),
    );
    console.log(
      JSON.stringify({
        level: 'INFO',
        function: 'listApplications',
        message: 'Applications retrieved successfully',
        totalApplications: result.Items?.length,
      }),
    );
    return {
      statusCode: 200,
      body: JSON.stringify(result.Items),
    };
  } catch (_error) {
    console.log(
      JSON.stringify({
        level: 'ERROR',
        function: 'listApplications',
        error: (_error as Error).message,
      }),
    );
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'Failed to list applications' }),
    };
  }
};
